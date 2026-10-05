module ApplicationHelper
  def status_badge_class(status)
    case status.to_s
    when "em_andamento", "aprovada", "validado", "pago", "finalizado"
      "badge-success"
    when "inscricoes_abertas", "pendente", "agendado"
      "badge-warning"
    when "rejeitada", "bloqueado", "atrasado", "cancelado"
      "badge-error"
    else
      "badge-neutral"
    end
  end

  def status_surface_class(status)
    case status.to_s
    when "em_andamento", "aprovada", "validado", "pago", "finalizado"
      "border-success/30 bg-success/10 text-success-content"
    when "inscricoes_abertas", "pendente", "agendado"
      "border-warning/30 bg-warning/10 text-warning-content"
    when "rejeitada", "bloqueado", "atrasado", "cancelado"
      "border-error/30 bg-error/10 text-error-content"
    else
      "border-base-300 bg-base-200 text-base-content"
    end
  end

  def status_select_class(status)
    case status.to_s
    when "em_andamento", "aprovada", "validado", "pago", "finalizado"
      "select-success"
    when "inscricoes_abertas", "pendente", "agendado"
      "select-warning"
    when "rejeitada", "bloqueado", "atrasado", "cancelado"
      "select-error"
    else
      "select-neutral"
    end
  end

  def championship_logo_url(championship)
    return unless championship_logo_attached?(championship)

    url_for(championship.logo)
  end

  def championship_logo_tag(championship, **options)
    return unless (logo_url = championship_logo_url(championship))

    image_tag(
      logo_url,
      {
        alt: "#{championship.name} logo",
        class: "h-16 w-16 object-contain"
      }.merge(options)
    )
  end

  def championship_logo_attached?(championship)
    championship&.logo&.attachment&.blob.present?
  end

  def championship_logo_filename(championship)
    championship&.logo&.attachment&.blob&.filename&.to_s
  end

  def championship_brand_style
    championship = @championship || @match&.championship || @team_stats_championship || @highlight_championship
    return if championship.blank?

    primary = championship.primary_color.to_s.match?(/\A#[0-9a-fA-F]{6}\z/) ? championship.primary_color : nil
    secondary = championship.secondary_color.to_s.match?(/\A#[0-9a-fA-F]{6}\z/) ? championship.secondary_color : nil
    styles = []
    if primary.present?
      styles << "--color-primary: #{primary}"
      styles << "--color-primary-content: #{championship_content_color(primary)}"
    end
    if secondary.present?
      styles << "--color-secondary: #{secondary}"
      styles << "--color-secondary-content: #{championship_content_color(secondary)}"
      styles << "--color-accent: #{secondary}"
      styles << "--color-accent-content: #{championship_content_color(secondary)}"
    end
    styles.join("; ")
  end

  def status_badge(status)
    tag.span status.to_s.tr("_", " ").humanize, class: ["badge", status_badge_class(status)]
  end

  def video_frame_for(url)
    return if url.blank?

    if url.match?(/\.(mp4|webm|ogg)(\?|#|$)/i)
      video_tag(url, controls: true, class: "aspect-video w-full rounded-2xl bg-black")
    elsif url.match?(%r{\Ahttps?://(www\.)?(youtube\.com/watch\?v=|youtu\.be/)}i)
      video_id = youtube_video_id(url)
      content_tag(:iframe, "", src: "https://www.youtube.com/embed/#{video_id}", class: "aspect-video w-full rounded-2xl", allowfullscreen: true, loading: "lazy", referrerpolicy: "strict-origin-when-cross-origin", title: "Melhores momentos")
    else
      link_to url, url, class: "link link-primary break-all", target: "_blank", rel: "noreferrer"
    end
  end

  def youtube_video_id(url)
    return unless url.present?

    if (match = url.match(%r{v=([^&]+)}))
      match[1]
    elsif (match = url.match(%r{youtu\.be/([^?&]+)}))
      match[1]
    end
  end

  private

  def championship_content_color(color)
    channels = color.delete_prefix("#").scan(/../).map { |channel| Integer(channel, 16) / 255.0 }
    luminance = channels.map do |channel|
      channel <= 0.04045 ? channel / 12.92 : ((channel + 0.055) / 1.055)**2.4
    end.then { |red, green, blue| (0.2126 * red) + (0.7152 * green) + (0.0722 * blue) }

    luminance > 0.179 ? "#111827" : "#FFFFFF"
  end
end
