module AthletesHelper
  def card_metric(label, value)
    content_tag :div, class: "rounded-2xl border border-slate-200 bg-slate-50 p-3 text-center" do
      safe_join([
        content_tag(:p, label, class: "text-[0.68rem] font-semibold uppercase tracking-[0.3em] text-slate-500"),
        content_tag(:p, value.to_i, class: "mt-2 text-2xl font-black text-slate-950")
      ])
    end
  end
end
