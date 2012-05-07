safe do
  local :path => "/var/backups/stage.benyehuda.org/:kind/:id"
 
  s3 do
    key "AKIAJAQH5UIRARAHXIZQ"
    secret "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"
    bucket "backup.benyehuda.org"
    path ":kind/:id"
  end
 
  keep do
    local 20
    s3 100
  end
 
  mysqldump do
    options "-ceKq --single-transaction --create-options -uastrails -pDM8VEgG4GMIQaN"
    user "astrails"
    password "DM8VEgG4GMIQaN"
    socket "/var/run/mysqld/mysqld.sock"
    database :benyehuda_stage
  end

  gpg do
    command "/usr/bin/gpg"
    options  "--no-use-agent"
    password "Udh567Rvg*I"
  end
 
  tar do
    options "-h"
    archive "stage-benyehuda-org" do
      files "var/www/staging.benyehuda.org"
      exclude ["/var/www/staging.benyehuda.org/current/log", "/var/www/staging.benyehuda.org/current/tmp"]
    end
  end
end
