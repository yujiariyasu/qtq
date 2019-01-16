$(document).on('turbolinks:load', function() {
  $('#learning-tags').tagit({
    fieldName: 'tag_names',
    singleField: true,
    placeholderText: 'タグを5つまで...',
    tagLimit: 5,
    caseSensitive: false
  });
  tag_string = $("#tag_hidden").val();
  try {
    tag_names = tag_string.split(',');
    results = [];
    for (i = 0, len = tag_names.length; i < len; i++) {
      tag = tag_names[i];
      results.push($('#learning-tags').tagit('createTag', tag));
    }
    return results;
  } catch (_error) {
    error = _error;
  }

  $('#edit-learning-tags').tagit({
    fieldName: 'tag_names',
    singleField: true,
    placeholderText: 'タグを5つまで...',
    tagLimit: 5,
    caseSensitive: false
  });
  tag_string = $("#tag_hidden").val();
  try {
    tag_names = tag_string.split(',');
    results = [];
    for (i = 0, len = tag_names.length; i < len; i++) {
      tag = tag_names[i];
      results.push($('#edit-learning-tags').tagit('createTag', tag));
    }
    return results;
  } catch (_error) {
    error = _error;
  }


});
