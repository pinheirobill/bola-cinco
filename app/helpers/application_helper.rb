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
end
