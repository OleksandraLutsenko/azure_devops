az storage account create \
  --name staccforsas01 \
  --resource-group OleksandraLutsenko \
  --location centralus \
  --sku Standard_LRS \
  --kind StorageV2 \
  --enable-hierarchical-namespace false

az storage container generate-sas \
  --account-name staccforsas01 \
  --name sastokenblob \
  --permissions r \
  --expiry 2025-01-22T23:59:59Z \
  --account-key 8Q6hxMQYXWCfqE1KHukTyYKR4zkd8MBuWFK/vucfnVYYf+TtA+t+9DRS2tStoqKCec+RGNW+OrbQ+AStY5gAnQ==


az storage message put \
    --queue-name mytestqueue \
    --content "Test message with SAS" \
    --sas-token "sv=2022-11-02&ss=q&srt=sco&sp=acup&se=2025-01-21T20:41:16Z&st=2025-01-21T12:41:16Z&sip=46.96.25.82&spr=https&sig=Bpm4M69%2F54XxeUmQRFsBuj1ceyhaxstM0Ljk9Tle9qw%3D" \
    --account-name staccforsas01 \
    --auth-mode key

az storage message peek \
    --queue-name mytestqueue \
    --sas-token "sv=2022-11-02&ss=q&srt=sco&sp=rlacup&se=2025-01-21T20:41:16Z&st=2025-01-21T12:41:16Z&sip=46.96.25.82&spr=https&sig=hFGU9mkr%2Bqdauq7LrhdET%2Fy%2Bd2m%2B9PuM2%2BHqhCvXw7Q%3D" \
    --account-name staccforsas01 \
    --auth-mode key

az storage entity query \
    --account-name staccforsas01 \
    --sas-token "sv=2022-11-02&ss=t&srt=sco&sp=rwdlacu&se=2025-01-21T20:41:16Z&st=2025-01-21T12:41:16Z&sip=46.96.25.82&spr=https&sig=esAWPo10OAfz%2B21VucDuRvu%2FoKZ9PCF0DFapNNOapUA%3D" \
    --table-name tableforsas \
    --filter "Singer='lana del Rey'"

