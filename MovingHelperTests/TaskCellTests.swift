//
//  TaskCellTests.swift
//  MovingHelper
//
//  Created by David on 2016/3/10.
//  Copyright © 2016年 Razeware. All rights reserved.
//

import UIKit
import XCTest
import MovingHelper

class TaskCellTests: XCTestCase {
	func testCheckingCheckboxMarksTaskDone() {
		let cell = TaskTableViewCell()
			
		//1
		let expectation = expectationWithDescription("Task updated")
			
		//2
		struct TestDelegate: TaskUpdatedDelegate {
			let testExpectation: XCTestExpectation
			let expectedDone: Bool

			init(updatedExpectation: XCTestExpectation,
				expectedDoneStateAfterToggle: Bool) {
					testExpectation = updatedExpectation
					expectedDone = expectedDoneStateAfterToggle
			}

			func taskUpdated(task: Task) {
				XCTAssertEqual(expectedDone, task.done, "Task done state did not match expected!")
				testExpectation.fulfill()
			}
		}
			
		//3
		let testTask = Task(aTitle: "TestTask", aDueDate: .OneMonthAfter)
		XCTAssertFalse(testTask.done, "Newly created task is already done!")
		cell.delegate = TestDelegate(updatedExpectation: expectation,
		expectedDoneStateAfterToggle: true)
		cell.configureForTask(testTask)
			
		//4
		XCTAssertFalse(cell.checkbox.isChecked, "Checkbox checked for not-done task!")
			
		//5
		cell.checkbox.sendActionsForControlEvents(.TouchUpInside)
			
		//6
		XCTAssertTrue(cell.checkbox.isChecked, "Checkbox not checked after tap!")
		waitForExpectationsWithTimeout(1, handler: nil)
	}
}