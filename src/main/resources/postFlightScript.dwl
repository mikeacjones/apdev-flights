%dw 2.0
import * from dw::core::Strings
//import dw::core::Strings
output application/java
//var numSeats = (a) -> 50 + a
fun numSeats(a) =
	if (a contains('737'))
		150
	else
		300
type myCurr = String {format: "#,###.00"}
type toDate = Date {format: "yyyy/MM/dd"}
type dateToString = String {format: "MMMM dd, yyyy"}
---
using (
	flights = payload..*return map {
		price: $.price,
		destination: $.destination,
		departureDate: $.departureDate as toDate,
		planeType: pluralize($.planeType),
		availableSeats: numSeats($.planeType)
	} as Object {
		class: "com.mulesoft.training.Flight"
	}
)
flights
	distinctBy $
	filter $.availableSeats > 150
	orderBy $.price 
	orderBy $.departureDate