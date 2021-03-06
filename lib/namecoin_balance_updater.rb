module NamecoinBalanceUpdater
  COIN = 1000000 # namecoin/src/main.h:static const int64 CENT = 1000000;

  def self.work
    Project.all.each do |project|
      start = 0
      count = 10
      loop do
        transactions = NamecoinDaemon.instance.list_transactions(project.address_label, count, start)
        break if transactions.empty?

        transactions.each do |transaction|
          if (transaction["category"] == "send") || Sendmany.find_by_txid(transaction["txid"])
            next
          end

          if deposit = Deposit.find_by_txid(transaction["txid"])
            deposit.update_attribute(:confirmations, transaction["confirmations"])
            next
          end

          deposit = Deposit.create({
            project_id: project.id,
            txid: transaction["txid"],
            confirmations: transaction["confirmations"],
            amount: (transaction["amount"].to_d * COIN).to_i,
            duration: 30.days.to_i,
            paid_out: 0,
            paid_out_at: Time.now
          })
        end

        break if transactions.size < count
        start += count
      end
    end
  end
end
