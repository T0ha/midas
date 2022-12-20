defmodule Portfolio.Repo.Migrations.CreateTriggerFetchAssetIfBalancePresent do
  use Ecto.Migration

  def up do
    fproc_q = 
      """
      CREATE FUNCTION set_fetch_flag_for_asset() RETURNS trigger AS $set_fetch_flag_for_asset$
        BEGIN
          UPDATE assets SET "fetch" = TRUE WHERE id = NEW.asset_id;
          RETURN NEW;
        END;
      $set_fetch_flag_for_asset$ LANGUAGE plpgsql;
      """
    trigger_q = 
      """
      CREATE TRIGGER set_fetch_flag_for_asset 
      AFTER INSERT ON balances FOR EACH ROW 
      EXECUTE PROCEDURE set_fetch_flag_for_asset();
      """
    execute(fproc_q)
    execute(trigger_q)
  end

  def down do
    fproc_q = 
      """
      DROP FUNCTION set_fetch_flag_for_asset();
      """

    trigger_q = 
      """
      DROP TRIGGER set_fetch_flag_for_asset ON balances;
      """
    execute(trigger_q)
    execute(fproc_q)
  end
end
