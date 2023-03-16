//
//  RunStatusLiveActivity.swift
//  RunStatus
//
//  Created by tae hoon park on 2023/03/16.
//

import ActivityKit
import WidgetKit
import SwiftUI

@main
struct RunStatusBundle: WidgetBundle {
  var body: some Widget {
    if #available(iOS 16.1, *) {
      RunStatusLiveActivity()
    }
  }
}

struct RunStatusLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: RunAttributes.self) { context in
      RunStateView(context: context)
        .activityBackgroundTint(Color.white)
        .activitySystemActionForegroundColor(Color.black)
    } dynamicIsland: { _ in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {}
        DynamicIslandExpandedRegion(.trailing) {}
        DynamicIslandExpandedRegion(.bottom) {}
      } compactLeading: {} compactTrailing: {} minimal: {}
    }
  }
}
