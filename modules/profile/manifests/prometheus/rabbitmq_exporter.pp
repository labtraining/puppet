class profile::prometheus::rabbitmq_exporter (
    $prometheus_nodes = hiera('profile::prometheus::rabbit_monitoring_host'),
    $rabbit_monitor_username = hiera('profile::prometheus::rabbit_monitor_user'),
    $rabbit_monitor_password = hiera('profile::prometheus::rabbit_monitor_pass'),
) {

    $rabbit_host = 'localhost:15672'
    file { '/etc/prometheus/rabbitmq-exporter.yaml':
        ensure  => 'present',
        owner   => 'prometheus',
        group   => 'prometheus',
        mode    => '0440',
        content => template('profile/prometheus/rabbitmq-exporter.conf.erb'),
    }

    require_package('prometheus-rabbitmq-exporter')

    service { 'prometheus-rabbitmq-exporter':
        ensure  => running,
        require => File['/etc/prometheus/rabbitmq-exporter.yaml'],
    }

    ferm::service { 'prometheus-rabbitmq-exporter':
        proto  => 'tcp',
        port   => '9195',
        srange => "@resolve((${prometheus_nodes}))",
    }
}
