package metrics

import (
	"time"

	metrics "github.com/armon/go-metrics"
	"github.com/cosmos/cosmos-sdk/telemetry"
)

// Measures the time taken to execute a sudo msg
// Metric Names:
//
//	sei_sudo_duration_miliseconds
//	sei_sudo_duration_miliseconds_count
//	sei_sudo_duration_miliseconds_sum
func MeasureSudoExecutionDuration(start time.Time, msgType string) {
	metrics.MeasureSinceWithLabels(
		[]string{"sei", "sudo", "duration", "milliseconds"},
		start.UTC(),
		[]metrics.Label{telemetry.NewLabel("type", msgType)},
	)
}

// Measures failed sudo execution count
// Metric Name:
//
//	sei_sudo_error_count
func IncrementSudoFailCount(msgType string) {
	telemetry.IncrCounterWithLabels(
		[]string{"sei", "sudo", "error", "count"},
		1,
		[]metrics.Label{telemetry.NewLabel("type", msgType)},
	)
}

// Gauge metric with seid version and git commit as labels
// Metric Name:
//
//	seid_version_and_commit
func GaugeSeidVersionAndCommit(version string, commit string) {
	telemetry.SetGaugeWithLabels(
		[]string{"seid_version_and_commit"},
		1,
		[]metrics.Label{telemetry.NewLabel("seid_version", version), telemetry.NewLabel("commit", commit)},
	)
}

// sei_tx_process_type_count
func IncrTxProcessTypeCounter(processType string) {
	metrics.IncrCounterWithLabels(
		[]string{"sei", "tx", "process", "type"},
		1,
		[]metrics.Label{telemetry.NewLabel("type", processType)},
	)
}

// Measures the time taken to process a block by the process type
// Metric Names:
//
//	sei_process_block_miliseconds
//	sei_process_block_miliseconds_count
//	sei_process_block_miliseconds_sum
func BlockProcessLatency(start time.Time, processType string) {
	metrics.MeasureSinceWithLabels(
		[]string{"sei", "process", "block", "milliseconds"},
		start.UTC(),
		[]metrics.Label{telemetry.NewLabel("type", processType)},
	)
}

// Measures the time taken to execute a sudo msg
// Metric Names:
//
//	sei_tx_process_type_count
func IncrDagBuildErrorCounter(reason string) {
	metrics.IncrCounterWithLabels(
		[]string{"sei", "dag", "build", "error"},
		1,
		[]metrics.Label{telemetry.NewLabel("reason", reason)},
	)
}

// Counts the number of concurrent transactions that failed
// Metric Names:
//
//	sei_tx_concurrent_delivertx_error
func IncrFailedConcurrentDeliverTxCounter() {
	metrics.IncrCounterWithLabels(
		[]string{"sei", "tx", "concurrent", "delievertx", "error"},
		1,
		[]metrics.Label{},
	)
}

// Counts the number of operations that failed due to operation timeout
// Metric Names:
//
//	sei_log_not_done_after_counter
func IncrLogIfNotDoneAfter(label string) {
	metrics.IncrCounterWithLabels(
		[]string{"sei", "log", "not", "done", "after"},
		1,
		[]metrics.Label{
			telemetry.NewLabel("label", label),
		},
	)
}

// Measures the time taken to execute a sudo msg
// Metric Names:
//
//	sei_deliver_tx_duration_miliseconds
//	sei_deliver_tx_duration_miliseconds_count
//	sei_deliver_tx_duration_miliseconds_sum
func MeasureDeliverTxDuration(start time.Time) {
	metrics.MeasureSince(
		[]string{"sei", "deliver", "tx", "milliseconds"},
		start.UTC(),
	)
}

// sei_oracle_vote_penalty_count
func SetOracleVotePenaltyCount(count uint64, valAddr string, penaltyType string) {
	metrics.SetGaugeWithLabels(
		[]string{"sei", "oracle", "vote", "penalty", "count"},
		float32(count),
		[]metrics.Label{
			telemetry.NewLabel("type", penaltyType),
			telemetry.NewLabel("validator", valAddr),
		},
	)
}

// sei_epoch_new
func SetEpochNew(epochNum uint64) {
	metrics.SetGauge(
		[]string{"sei", "epoch", "new"},
		float32(epochNum),
	)
}

// Measures throughput
// Metric Name:
//
//	sei_throughput_<metric_name>
func SetThroughputMetric(metricName string, value float32) {
	telemetry.SetGauge(
		value,
		"sei", "throughput", metricName,
	)
}
