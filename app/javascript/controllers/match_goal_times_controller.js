import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    teamAName: String,
    teamBName: String
  }

  static targets = [
    "scoreA",
    "scoreB",
    "teamAFields",
    "teamBFields",
    "teamACount",
    "teamBCount",
    "totalCount"
  ]

  connect() {
    this.refresh()
  }

  refresh() {
    const countA = this.scoreValue(this.scoreATarget)
    const countB = this.scoreValue(this.scoreBTarget)

    this.renderSide(this.teamAFieldsTarget, "a", countA, this.teamACountTarget, this.teamANameValue || "Equipe A")
    this.renderSide(this.teamBFieldsTarget, "b", countB, this.teamBCountTarget, this.teamBNameValue || "Equipe B")

    if (this.hasTotalCountTarget) {
      this.totalCountTarget.textContent = countA + countB
    }
  }

  scoreValue(target) {
    const raw = target.value.toString().trim()
    if (raw === "") return 0

    const parsed = Number.parseInt(raw, 10)
    return Number.isNaN(parsed) || parsed < 0 ? 0 : parsed
  }

  renderSide(container, side, count, badgeTarget, teamName) {
    const currentValues = this.collectValues(container)

    container.replaceChildren()

    if (badgeTarget) {
      badgeTarget.textContent = count
    }

    if (count === 0) {
      const empty = document.createElement("div")
      empty.className = "rounded-2xl border border-dashed border-base-300 bg-base-100 px-4 py-3 text-sm text-base-content/60"
      empty.textContent = `Sem gols informados para ${teamName}.`
      container.appendChild(empty)
      return
    }

    for (let index = 0; index < count; index += 1) {
      container.appendChild(this.buildGoalRow(side, index, currentValues[index] || { minute: "", penalty: false }))
    }
  }

  collectValues(container) {
    return Array.from(container.querySelectorAll("[data-goal-row]")).map((row) => {
      const minuteInput = row.querySelector("[data-goal-minute-input]")
      const penaltyInput = row.querySelector("[data-goal-penalty-input]")

      return {
        minute: minuteInput?.value || "",
        penalty: penaltyInput?.checked || false
      }
    })
  }

  buildGoalRow(side, index, value) {
    const row = document.createElement("div")
    row.className = "rounded-2xl border border-base-300 bg-base-200 p-4 shadow-sm"
    row.dataset.goalRow = "true"

    const header = document.createElement("div")
    header.className = "flex flex-wrap items-start justify-between gap-3"

    const heading = document.createElement("div")
    const label = document.createElement("p")
    label.className = "text-sm font-semibold text-base-content/80"
    label.textContent = `Gol ${index + 1}`
    const description = document.createElement("p")
    description.className = "text-xs text-base-content/50"
    description.textContent = "Adicione o minuto e marque se foi de pênalti."
    heading.append(label, description)

    const penaltyLabel = document.createElement("label")
    penaltyLabel.className = "inline-flex items-center gap-2 rounded-full border border-base-300 bg-base-100 px-3 py-2 text-xs font-semibold"

    const penaltyHidden = document.createElement("input")
    penaltyHidden.type = "hidden"
    penaltyHidden.name = `match[goal_penalties_${side}][${index}]`
    penaltyHidden.value = "0"

    const penalty = document.createElement("input")
    penalty.type = "checkbox"
    penalty.name = `match[goal_penalties_${side}][${index}]`
    penalty.value = "1"
    penalty.checked = Boolean(value?.penalty)
    penalty.className = "checkbox checkbox-primary checkbox-sm"
    penalty.dataset.goalPenaltyInput = "true"
    penalty.dataset.action = "change->match-goal-times#refresh"

    const penaltyText = document.createElement("span")
    penaltyText.textContent = "Pênalti"

    penaltyLabel.append(penaltyHidden, penalty, penaltyText)
    header.append(heading, penaltyLabel)

    const body = document.createElement("div")
    body.className = "mt-4 grid gap-3 sm:grid-cols-[5.5rem_minmax(0,1fr)] sm:items-center"

    const input = document.createElement("input")
    input.type = "text"
    input.name = `match[goal_minutes_${side}][]`
    input.value = value?.minute || ""
    input.maxLength = 2
    input.inputMode = "numeric"
    input.placeholder = "05"
    input.className = "input input-bordered w-full"
    input.dataset.goalMinuteInput = "true"
    input.dataset.action = "input->match-goal-times#refresh"

    const minuteLabel = document.createElement("div")
    minuteLabel.className = "rounded-xl bg-base-100 px-3 py-3 text-sm font-semibold text-base-content/70"
    minuteLabel.textContent = `Minuto ${index + 1}`

    body.append(minuteLabel, input)
    row.append(header, body)
    return row
  }
}
