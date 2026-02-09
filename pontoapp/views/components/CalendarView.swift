//
//  CalendarView.swift
//  pontoapp
//
//  Created by Erick Costa on 06/12/25.
//

import SwiftUI

struct CalendarView: View {
    @State var currentDate: Date = Date()
    @State private var selectedDate: Date = Date()
    
    @Binding var daysCheckedIn: [Int: RecordStatus]
    
    //var onDateSelected: ((Date) -> Void)
    
    var seeRecords: ((_ month: Int, _ year: Int) -> Void)
    
    var body: some View {
        VStack(spacing: 10){
            VStack(spacing: 20){
                HStack{
                    Text(currentDate.formatMonthAndYear().capitalized)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.bottom, 8)
                        .padding(.horizontal, 8)
                        .overlay(alignment: .bottom) {
                            Capsule()
                                .fill(.gradientEnd)
                                .frame(height: 5)
                        }
                    
                    Spacer()
                    
                    HStack(spacing: 20){
                        Button {
                            withAnimation(.easeInOut){
                                changeMonth(by: -1)
                                seeRecords(currentDate.month, currentDate.year)
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(Font.system(size: 24))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                        
                        Button {
                            withAnimation(.easeInOut){
                                changeMonth(by: 1)
                                seeRecords(currentDate.month, currentDate.year)
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(Font.system(size: 24))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(.horizontal)
                
                HStack(spacing: 0) {
                    ForEach(["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"], id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.gray)
                    }
                }
                
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                
                LazyVGrid(columns: columns, spacing: 2){
                    ForEach(currentDate.daysOfMonth()){ value in
                        if value.day != -1{
                            let isToday = Calendar.current.isDateInToday(value.date)
                            let isSelected = Calendar.current.isDate(value.date, inSameDayAs: selectedDate)
                            
                            VStack{
                                Text("\(value.day)")
                                    .fontWeight(.medium)
                                    .foregroundColor( verifyTextColor(day: value.day))
                                    .frame(width: 22, height: 22)
                                    .background(
                                        isToday ? Circle().fill(Color.blue.opacity(0.4)) : (isSelected ? Circle().fill(.gradientEnd.opacity(0.5)) : nil)
                                    )
                                
                                if let dayStatus = daysCheckedIn[value.day]{
                                    Circle()
                                        .fill(getColorFromStatus(status: dayStatus))
                                        .frame(width: 8, height: 8)
                                } else {
                                    Circle()
                                        .fill(Color.clear)
                                        .frame(width: 8, height: 8)
                                }
                            }
                            .onTapGesture {
                                withAnimation{
                                    self.selectedDate = value.date
                                }
                                
                                //onDateSelected(value.date)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            Text("")
                                .frame(width: 28, height: 28)
                            
                        }
                        
                    }
                }
            }
            RoundedRectangle(cornerRadius: 10)
                .frame(maxWidth: .infinity)
                .frame(height: 4)
                .foregroundStyle(.gray.opacity(0.5))
                .padding(.horizontal, 8)
            
            VStack(alignment: .leading){
                Text("Legenda:")
                    .fontWeight(.semibold)
                    .font(.headline)
                
                HStack{
                    Group{
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.green)
                        Text("Presente")
                            .font(.subheadline)
                            .opacity(0.9)
                    }
                    Spacer()
                    Group{
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.yellow)
                        Text("Atraso")
                            .font(.subheadline)
                            .opacity(0.9)
                    }
                    Spacer()
                    Group{
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.red)
                        Text("Ausência")
                            .font(.subheadline)
                            .opacity(0.9)
                    }
                }
            }
            .foregroundStyle(.white)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 15)
        .background(.bg900)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding()
        
    }
    
    
    func changeMonth(by offset: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: offset, to: currentDate) {
            currentDate = newDate
        }
    }
    
    func verifyTextColor(day: Int) -> Color{
        return .white
    }
    
    func getColorFromStatus(status: RecordStatus) -> Color {
        switch status {
        case .absent:
            return .red
        case .lated:
            return .yellow
        case .present:
            return .green
        }
    }
}

#Preview {
    CalendarView(daysCheckedIn: .constant([
        10: .present,
        12: .absent,
        15: .lated
    ])) { month, year in
        print("Mudou para \(month)/\(year)")
    }
}
