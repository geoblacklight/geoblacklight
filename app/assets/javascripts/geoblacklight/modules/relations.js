Blacklight.onLoad(function () {
    $('[data-relations="true"]').each(function (i, element) {
        var $elem = $(element);
        var attributes = $elem.data();
        var relation_url = attributes['url'] + '/relations';
        $.ajax({
            url: relation_url,
            type: 'GET',
            dataType: 'html',
            success: function (data) {
                $elem.append($(data).hide().fadeIn(200));
            }
        })
    });
});