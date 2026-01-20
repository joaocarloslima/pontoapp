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
    
    let daysWithPoint: [Int] = [1, 2, 3, 4, 5, 8, 9, 10, 11, 12]
    
    var onDateSelected: ((Date) -> Void)
    
    var body: some View {
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
                                .frame(width: 28, height: 28)
                                .background(
                                    isToday ? Circle().fill(Color.blue.opacity(0.4)) : (isSelected ? Circle().fill(.gradientEnd.opacity(0.5)) : nil)
                                )
                            
                            if daysWithPoint.contains(value.day){
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 8, height: 8)
                            } else {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 6, height: 6)
                            }
                        }
                        .onTapGesture {
                            withAnimation{
                                self.selectedDate = value.date
                            }
                            
                            onDateSelected(value.date)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    } else {
                        Text("")
                            .frame(width: 28, height: 28)
                        
                    }
                    
                }
            }
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
}

#Preview {
    CalendarView(){ _ in
        
    }
}
