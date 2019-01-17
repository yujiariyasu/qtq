$(document).on('turbolinks:load', function() {
  $('#learning-tags, #edit-learning-tags').tagit({
    fieldName: 'tag_names',
    singleField: true,
    placeholderText: 'タグを5つまで...',
    tagLimit: 5,
    caseSensitive: false,
    availableTags: gon.tag_list
  });
});
