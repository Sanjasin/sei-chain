package types

import (
	"sort"
)

func NewMatchResult(
	orders []*Order,
	cancellations []*Cancellation,
	settlements []*SettlementEntry,
) *MatchResult {
	sort.SliceStable(orders, func(i, j int) bool {
		return orders[i].String() < orders[j].String()
	})
	sort.SliceStable(cancellations, func(i, j int) bool {
		return cancellations[i].String() < cancellations[j].String()
	})
	sort.SliceStable(settlements, func(i, j int) bool {
		return settlements[i].String() < settlements[j].String()
	})
	return &MatchResult{
		Orders:        orders,
		Cancellations: cancellations,
		Settlements:   settlements,
	}
}
