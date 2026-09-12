module UiHelper
  def page_header(title:, subtitle: nil, badge: nil, actions: [], title_editor: nil)
    render partial: "components/page_header", locals: {
      title: title,
      subtitle: subtitle,
      badge: badge,
      actions: Array(actions),
      title_editor: title_editor
    }
  end

  def surface_card(title: nil, subtitle: nil, badge: nil, actions: [], id: nil, classes: "", &block)
    render partial: "components/surface_card", locals: {
      title: title,
      subtitle: subtitle,
      badge: badge,
      actions: Array(actions),
      id: id,
      classes: classes,
      body: block_given? ? capture(&block) : "".html_safe
    }
  end

  def stats_grid(stats, columns: "md:grid-cols-2 xl:grid-cols-4")
    render partial: "components/stats_grid", locals: {
      stats: stats,
      columns: columns
    }
  end

  def empty_state(title:, description:, action: nil)
    render partial: "components/empty_state", locals: {
      title: title,
      description: description,
      action: action
    }
  end

  def championship_stepper(championship, current_step, step_labels, path_helper: :championship_path)
    render partial: "components/championship_stepper", locals: {
      championship: championship,
      current_step: current_step,
      step_labels: step_labels,
      path_helper: path_helper
    }
  end

  def match_card(match, compact: false)
    render partial: "components/match_card", locals: {
      match: match,
      compact: compact
    }
  end

  def team_card(team, compact: false)
    render partial: "components/team_card", locals: {
      team: team,
      compact: compact
    }
  end

  def athlete_card(athlete, compact: false)
    render partial: "components/athlete_card", locals: {
      athlete: athlete,
      compact: compact
    }
  end

  def standing_table(category, rows, group_key: nil, position_offset: 0, tranca: false, show_header: true)
    render partial: "components/standing_table", locals: {
      category: category,
      rows: rows,
      group_key: group_key,
      position_offset: position_offset,
      tranca: tranca,
      show_header: show_header
    }
  end

  def tranca_group_key_label(group_key)
    text = group_key.to_s.squish
    text = text.sub(/\ACHAVE\s+/i, "").squish
    return if text.blank?

    numeric = text.match?(/\A\d+\z/)
    return alphabet_label(text.to_i) if numeric

    text.upcase
  end

  def ranking_entry_card(entry)
    render partial: "components/ranking_entry_card", locals: {
      entry: entry
    }
  end

  def standing_row_card(row)
    render partial: "components/standing_row_card", locals: {
      row: row
    }
  end

  def filter_bar(title: nil, subtitle: nil, search_label: nil, search_value: nil, search_param: :q, action: nil)
    render partial: "components/filter_bar", locals: {
      title: title,
      subtitle: subtitle,
      search_label: search_label,
      search_value: search_value,
      search_param: search_param,
      action: action
    }
  end

  private

  def alphabet_label(index)
    number = index.to_i
    return "A" if number <= 1

    letters = +""
    while number.positive?
      number, remainder = (number - 1).divmod(26)
      letters.prepend(("A".ord + remainder).chr)
    end
    letters
  end
end
