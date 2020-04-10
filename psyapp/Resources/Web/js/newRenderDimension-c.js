function RenderTemplate(root, dimensions, article_content, overdue, child_exam_id = null) {
    
    //标记量表是否全部完成(iOS)
    var isAllCompleted = true;
    
  if (dimensions && dimensions.length > 0 && article_content) {
    dimensions.forEach(dimension => {
      var child_dimension_id = dimension.child_dimension_id;
      var dimension_id = dimension.dimension_id;
      var reg = new RegExp(
        "<dimension[\\s\\xA0]+:dimension=\"dimensions\\['" +
        dimension_id +
        "'\\].+?</dimension>"
      );
      var start = '<div class="dimension-box">';
      var startGood = '<div class="dimension-box good">';
      var startBad = '<div class="dimension-box bad">';
      var startcom = '<div class="dimension-box complete">';
      var noAStart = "<div>";
      var details = "<a href='cheersgenie://test/dimension?";
      var report = "<a href='cheersgenie://test/dimension/report?";
      var url =
        "child_dimension_id=" +
        child_dimension_id +
        "&child_exam_id=" +
        child_exam_id +
        "&dimension_id=" +
        dimension_id +
        "'>";

      var button = '<div class="button"><img src="./images/button.png"></div>';

      var name = "<p>" + dimension.dimension_name;
      var score = "</p>";
      if (
        dimension.score !== "null" &&
        dimension.score !== null &&
        dimension.score != undefined
      ) {
        score = "<span>" + dimension.score + "</span></p>";
      }
      var report_forbid =
        '<div class="result"><span>学校未开放报告查看</span></div>';
      var uncomplete = '<div class="result"><span>未完成</span></div>';
      var over = '<div class="result"><span>已过期</span></div>';
      var ban = '<div class="result"><span>测评需在购买课程后才能使用</span></div>';
      var complete = '<div class="result"><span>已完成</span></div>';
      var result = '<div class="result">';
      if (dimension.result && dimension.result.indexOf("、") !== -1) {
        resultArr = dimension.result.split("、");
        resultArr.forEach(res => {
          result = result + "<span>" + res + "</span>";
        });
        result = result + "</div>";
      } else {
        result = result + "<span>" + dimension.result + "</span></div>";
      }
      var aEnd = "</a>";
      var noAend = "</div>";
      var end = "</div>";
      var template = "";
      var status =
        dimension.status == 1 ||
        (dimension.status == 0 && dimension.report_status == 1);
      var hasResult =
        (dimension.is_merge_answer &&
          dimension.results &&
          dimension.results.length > 0) ||
        (!dimension.is_merge_answer && dimension.result);

      if (child_exam_id) {
        if (status && hasResult && !dimension.report_forbid) {
          if (dimension.is_merge_answer) {
            template =
              startcom +
              report +
              url +
              button +
              name +
              score +
              complete +
              aEnd +
              end;
          } else {
            if (dimension.is_bad_tendency) {
              template = startBad + report + url + button + name + score;
            } else {
              template = startGood + report + url + button + name + score;
            }
            template = template + result + aEnd + end;
          }
        } else if (status && dimension.report_forbid) {
          template =
            start +
            noAStart +
            button +
            name +
            score +
            report_forbid +
            noAend +
            end;
        } else if (status) {
          template =
            startcom +
            report +
            url +
            button +
            name +
            score +
            complete +
            aEnd +
            end;
        } else {
          if (overdue === true || overdue === "true") {
            template = start + noAStart + button + name + score + over + noAend + end;
          } else {
            template =
              start + details + url + button + name + score + uncomplete + aEnd + end;
          }
        }
      } else {
        template = start + noAStart + button + name + score + ban + noAend + end;
      }
      article_content = article_content.replace(reg, template);
       
      //(iOS)
      if (status == false) {
         isAllCompleted = false;
      }
     
    });
  } else {
    var reg = new RegExp("<dimension[\\s\\xA0]+:dimension=.+?</dimension>");
    var template = "<div>[dimension数据为空]<div>";
    if (article_content) {
      article_content = article_content.replace(reg, template);
    } else {
      article_content = template;
    }
  }
  article_content = article_content
    .replace(/<la/g, "<a")
    .replace(/<\/la>/g, "</a>");
  root.innerHTML = article_content;
  
    
  //回调高度(iOS)
  var callBack = function () {window.webkit.messageHandlers.contentDidChange.postMessage({
             "height": root.offsetHeight
          })}
                                                                        
   var imgs = root.getElementsByTagName("img");
   var imgTotal = imgs.length
   if (imgTotal == 0) {
      callBack()
   } else {
     var flag = 0
     for (var i = 0; i < imgTotal; i ++) {
        imgs[i].onload = imgs[i].onreadystatechange = function() {
           if (!this.readyState || this.readyState == 'loaded'||this.readyState == 'complete') {
              flag++
              if (flag == imgTotal) {
                  callBack()
              }
           }
        }
     }
   }
                                                                           
   //用app端获取量表的完成情况(iOS)
   window.webkit.messageHandlers.testCompleteStatus.postMessage({
          "isAllCompleted" : isAllCompleted
   })
}

window.JSBridge = {
  getData: function(data) {
   
     var dimensions = data.dimensions;
     var article_content = data.article_content;
     var overdue = data.overdue;
     var child_exam_id = data.child_exam_id;
     var root = document.getElementById("article_content");
     
     RenderTemplate(root, dimensions, article_content, overdue, child_exam_id);
  }
 

};
