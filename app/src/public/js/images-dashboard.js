"use strict";

window.reload = (id,org) => {

  $(id + ' tr[name]').each((_,tr) => {
    const repo = $(tr).attr('name');
    $.ajax({
      url: `/build?org=${org}&repo=${repo}`,
      success: (build) => {
        $('td span.state', tr).html(coloured_state(build.state));
        $('td span.age',   tr).html(coloured_age(build.age));
        $('td span.took',  tr).html(build.took);
      }
    });
  });

  const coloured_state = (state) => {
    switch (state) {
      case 'failed':
        return red(state);
      case 'passed':
        return green(state);
      default:
        return black(state);
    }
  };

  const coloured_age = (age) => {
    if (age.includes('Day') || age.includes('Week') || age.includes('Month'))
      return red(age);
    else
      return black(age);
  };

  const red = (value) => {
    return coloured('red',value);
  };

  const green = (value) => {
    return coloured('green',value);
  };

  const black = (value) => {
    return coloured('black',value);
  };

  const coloured = (colour, value) => {
    return '<span style="color:'+colour+';">'+value+'</span>';
  };
};
