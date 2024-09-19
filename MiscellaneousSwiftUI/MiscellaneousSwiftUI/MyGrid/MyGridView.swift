//
//  MyGridView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 9/19/24.
//

import SwiftUI

struct MyGridView: View {
    var body: some View {
        ScrollView {
            grid_1
            
            Divider()
            
            grid_2
        }
    }
    
    @ViewBuilder private var grid_1: some View {
        Grid(alignment: .leading) { 
            GridRow { 
                Text("Hello!")
                    .background { 
                        Color.cyan
                    }
                
                Text("Hello!")
                    .background { 
                        Color.orange
                    }
                
            }
            
            Divider()
                .gridCellUnsizedAxes(.horizontal)
            
            GridRow { 
                Text("HelloHello12!")
                    .background { 
                        Color.cyan
                    }
                
                Text("HelloHello12!")
                    .background { 
                        Color.orange
                    }
            }
            
            Divider()
                .gridCellUnsizedAxes(.horizontal)
            
            GridRow { 
                Color.yellow
                    .frame(width: 20.0, height: 20.0)
                    .gridCellAnchor(.topLeading)
            }
            
            GridRow { 
                Color.blue
                    .frame(height: 20.0)
                    .gridCellColumns(2)
                    .gridCellUnsizedAxes(.horizontal)
            }
            
            Divider()
                .gridCellUnsizedAxes(.horizontal)
            
            GridRow { 
                Text("HelloHelloHelloHello!")
                    .background { 
                        Color.cyan
                    }
                    .gridCellUnsizedAxes(.horizontal)
                
                Text("HelloHelloHelloHello!")
                    .background { 
                        Color.orange
                    }
                    .gridCellUnsizedAxes(.horizontal)
            }
            .gridColumnAlignment(.trailing)
        }
    }
    
    @ViewBuilder private var grid_2: some View {
        Grid(alignment: .leadingFirstTextBaseline) { 
            GridRow { 
                Text("HelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHello!")
                    .background { 
                        Color.orange
                    }
                
                Text("Foo")
                    .font(.title)
                    .background { 
                        Color.cyan
                    }
            }
            
            GridRow { 
                Text("Fooo")
                    .gridCellColumns(2)
                    .background { 
                        Color.yellow
                    }
            }
        }
    }
}

#Preview {
    MyGridView()
}
