$(function(){
  //inner html data
    var bukuma_html = "";
    var blog_html = "";

  // for ajax
    var controll_data = {};

  $.ajax({
        type : 'POST',
        url : '/getBukuma',
        data : controll_data,
        cache : false,
        dataType : 'json',

        success : function(json) {
          bukuma_html = '<div class="carousel-inner">';

          for(var i = 0; i < 10; i++){
            if(i === 0) {
              bukuma_html = bukuma_html.concat('<div class="item active"><div class="box-testimonial"><div class="oComment">');
            }else{
              bukuma_html = bukuma_html.concat('<div class="item "><div class="box-testimonial"><div class="oComment">');
            }
            bukuma_html = bukuma_html.concat('<h5><a href="' + json.entries[i].target_url + '" target="_blank">' + json.entries[i].target_title + '</a> - <a href="' + json.entries[i].hatebu_url + '" target="_blank" style="color:#ff1493; text-decoration:underline;">' + json.entries[i].hatebu_count + 'users</a></h5>');

            if(json.entries[i].comment != ''){
                bukuma_html = bukuma_html.concat('<p>' + json.entries[i].comment + '</p>');
            }else{
              bukuma_html = bukuma_html.concat('<p>（コメントなし）</p>');
            }

            bukuma_html = bukuma_html.concat('<div class="text-right date-post"><small>Posted at : ' + json.entries[i].date + '</small></div>');
            bukuma_html = bukuma_html.concat('</div><img src="img_org/icon_big.png" alt=""></div></div>');

          }
          bukuma_html = bukuma_html.concat('</div><div class="control-testi-slider"><a href="#testimonial-slider" data-slide="prev"><i class="fa fa-chevron-left"></i></a><a href="#testimonial-slider" data-slide="next"><i class="fa fa-chevron-right"></i></a></div>');
          $("#bukuma-area").html( bukuma_html );
        },
        complete : function() {
          //騾壻ｿ｡邨ゆｺ�
        }
    });
});