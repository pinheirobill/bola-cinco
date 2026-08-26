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
    const values = currentValues.length > 0 ? currentValues : []

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
      container.appendChild(this.buildGoalRow(side, index, values[index] || ""))
    }
  }

  collectValues(container) {
    return Array.from(container.querySelectorAll("[data-goal-minute-input]")).map((input) => input.value)
  }

  buildGoalRow(side, index, value) {
    const row = document.createElement("div")
    row.className = "grid gap-2 sm:grid-cols-[5.5rem_minmax(0,1fr)]"

    const label = document.createElement("div")
    label.className = "rounded-xl bg-base-200 px-3 py-3 text-sm font-semibold text-base-content/70"
    label.textContent = `Gol ${index + 1}`

    const input = document.createElement("input")
    input.type = "text"
    input.name = `match[goal_minutes_${side}][]`
    input.value = value
    input.maxLength = 2
    input.inputMode = "numeric"
    input.placeholder = "05"
    input.className = "input input-bordered w-full"
    input.dataset.goalMinuteInput = "true"
    input.dataset.action = "input->match-goal-times#refresh"

    row.append(label, input)
    return row
  }
}
