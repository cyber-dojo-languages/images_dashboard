
window.reload = function(id,org) {
  const space = ' ';
  $(id + space + 'tr[name]').each(function() {
    const tr = $(this);
    const repo = tr.attr('name');
    $('td span.status', tr).html('');
    $('td span.age',    tr).html('');
    $('td span.took',   tr).html('');
  });

  $(id + space + 'tr[name]').each(function() {
    const tr = $(this);
    const repo = tr.attr('name');
    $.ajax({
      url: `/build?org=${org}&repo=${repo}`,
      success: function(build) {
        var colour, html;
        switch (build.status) {
          case 'failed':
            colour = 'red'; break;
          case 'passed':
            colour = 'green'; break;
          default:
            colour = 'black'; break;
        }
        html = `<span style="color:${colour};">${build.status}</span>`;
        $('td span.status', tr).html(html);
        $('td span.age',    tr).html(build.age);
        $('td span.took',   tr).html(build.took);
      }
    });
  });
};
