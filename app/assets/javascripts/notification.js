requestPermission = function() {
Notification.requestPermission().then((permission) => {
    switch (permission) {
      case 'granted':
        // 許可された場合
        break;
      case 'denied':
        // ブロックされた場合
        break;
      case 'default':
        // 無視された場合
        break;
      default:
        break;
    }
});
}


notification = function(user_id) {
title    = '見出し';
options  = {
    body : '本文',
    icon : 'アイコン画像のパス',
    data : {
      url : 'https://www.qtq.work/'
     }
};
notification = new Notification(title, options);
notification.addEventListener('click', (event) => {
  location.href = event.srcElement.data.url
}, false);
}
