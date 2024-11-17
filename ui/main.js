window.addEventListener('message', (event) => {
    let data = event.data
     if (data.action == "draw") {
        $('#text').text(data.text)
        $('.rell').text(data.button)
        console.log('fade in')
        $(".access").fadeIn(1500)
    } else if (data.action =="stopDraw") {
        $(".access").fadeOut(100)
    }
});