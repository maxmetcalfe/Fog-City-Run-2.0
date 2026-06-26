class ResetResultsIdSequence < ActiveRecord::Migration[6.1]
  def up
    # Reset the PostgreSQL sequence to avoid duplicate key violations.
    # The old code manually assigned IDs via Result.maximum(:id) + 1,
    # which bypassed the auto-increment sequence.  When we switched to
    # letting the DB auto-generate IDs, nextval could return a value
    # that already exists in the table.
    execute("SELECT setval('results_id_seq', (SELECT COALESCE(MAX(id), 0) + 1 FROM results), false);")
  end

  def down
    # No good way to revert a sequence reset — this is purely corrective.
  end
end