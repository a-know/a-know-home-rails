$(function(){
  //inner html data
    var blog_html = "";

  //ajax通信用のコントロールデータ作成
    var controll_data = {};

  $.ajax({
        type : 'POST',
        url : '/getBlogRss',
        data : controll_data,
        cache : false,
        dataType : 'json',

        success : function(json) {

          for(var i = 0; i < 4; i++){
            blog_html = blog_html.concat('<div class="job clearfix"><div class="col-xs-3">');
            blog_html = blog_html.concat('<div class="where">' + json.entries[i].date + '</div></div><div class="col-xs-9">');
            if(json.entries[i].hatebu_count != ''){
              blog_html = blog_html.concat('<div class="profession"><a href="' + json.entries[i].target_url + '" target="_blank">' + json.entries[i].target_title + '</a> <a href="' + json.entries[i].hatebu_url + '" target="_blank" style="color:#ff1493; text-decoration:underline;">' + json.entries[i].hatebu_count + 'users</a></div>');
            }else{
              blog_html = blog_html.concat('<div class="profession"><a href="' + json.entries[i].target_url + '" target="_blank">' + json.entries[i].target_title + '</a></div>');
            }
            blog_html = blog_html.concat('<div class="description">' + json.entries[i].description + '</div></div></div>');
          }
            $("#blog-rss-area").html( blog_html );
        },
        complete : function() {
          //通信終了
        }
    });
});
$(function(){
    $('#accordion_head').click(function() {
        $(this).next().slideToggle();
    }).next().hide();
});