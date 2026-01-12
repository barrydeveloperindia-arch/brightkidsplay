# Antigravity Sync Protocol 🔄

To ensure a seamless transition between laptops, we use this **Repository** as the single source of truth for both Code and Agent Context.

## 1. The "Brain" in the Repo
We treat the `documentation/` directory as the portable brain. It contains:
- `project_tasks.md`: The master checklist of what is done and what is next.
- `design_vision_and_flowchart.md`: The architectural blueprint.
- `implementation_plan.md`: The current technical specs.

## 2. Switching Laptops (User Workflow)

### Before leaving Laptop A:
1.  **Ask the Agent**: "Please archive all plans and tasks to the repo."
    *   *Agent Action*: Copies internal artifacts to `documentation/`.
2.  **Commit & Push**:
    ```powershell
    git add documentation/
    git commit -m "chore: sync agent state for handover"
    git push origin master
    ```

### Starting on Laptop B:
1.  **Pull changes**:
    ```powershell
    git pull origin master
    ```
2.  **Prime the Agent**:
    "I am resuming work. Please read `documentation/project_tasks.md` and `documentation/design_vision_and_flowchart.md` to understand the current state."

## 3. Agent Rules (System Prompting)
*When you start a session in this repo, you MUST:*
1.  Check for the existence of `documentation/project_tasks.md`.
2.  If it exists, USE IT as your primary task list (overwrite your internal blank state).
3.  Before finishing a task, UPDATE `documentation/project_tasks.md` so the next session is accurate.

---
*By following this protocol, "The Environment" travels with the code.* 🚀
