//
//  GTRepositorySpec.m
//  ObjectiveGitFramework
//
//  Created by Etienne Samson on 2013-07-10.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import "GTRepository.h"

SpecBegin(GTRepositoryManipulation)

NSURL *repositoryURL = [NSURL fileURLWithPath:@"/tmp/Objective-Git/test-repo" isDirectory:YES];
__block GTRepository *repository;

beforeAll(^{
	NSError *error = nil;
	repository = [GTRepository createRepositoryAtURL:repositoryURL error:&error];
	expect(repository).notTo.beNil();
	expect(error.description).to.beNil();
});

afterAll(^{
	NSError *error = nil;
	[[NSFileManager defaultManager] removeItemAtURL:repositoryURL error:&error];
	expect(error.description).to.beNil();
});

describe(@"GTRepository", ^{
	it(@"allows commits to be created easily", ^{
		NSError *error = nil;
		__block NSError *builderError;
		GTCommit *initial = [repository buildCommitWithMessage:@"Initial commit" parents:nil error:&error block:^(GTTreeBuilder *builder) {
			expect(builder).toNot.beNil();
			[builder addEntryWithData:[@"Test contents" dataUsingEncoding:NSUTF8StringEncoding] filename:@"Test file.txt" filemode:GTFileModeBlob error:&builderError];
			expect(builderError.description).to.beNil();
			[builder addEntryWithData:[@"Another file contents" dataUsingEncoding:NSUTF8StringEncoding] filename:@"subdir/Test file 2.txt" filemode:GTFileModeBlob error:&builderError];
			expect(builderError.description).to.beNil();
		}];
		expect(initial).notTo.beNil();
		expect(error.description).to.beNil();
	});
});

//describe(@"-preparedMessage", ^{
//	it(@"should return nil by default", ^{
//		__block NSError *error = nil;
//		expect([repository preparedMessageWithError:&error]).to.beNil();
//		expect(error).to.beNil();
//	});
//
//	it(@"should return the contents of MERGE_MSG", ^{
//		NSString *message = @"Commit summary\n\ndescription";
//		expect([message writeToURL:[repository.gitDirectoryURL URLByAppendingPathComponent:@"MERGE_MSG"] atomically:YES encoding:NSUTF8StringEncoding error:NULL]).to.beTruthy();
//
//		__block NSError *error = nil;
//		expect([repository preparedMessageWithError:&error]).to.equal(message);
//		expect(error).to.beNil();
//	});
//});
//
//describe(@"-mergeBaseBetweenFirstOID:secondOID:error:", ^{
//	it(@"should find the merge base between two branches", ^{
//		NSError *error = nil;
//		GTBranch *masterBranch = [[GTBranch alloc] initWithName:@"refs/heads/master" repository:repository error:&error];
//		expect(masterBranch).notTo.beNil();
//		expect(error).to.beNil();
//
//		GTBranch *otherBranch = [[GTBranch alloc] initWithName:@"refs/heads/other-branch" repository:repository error:&error];
//		expect(otherBranch).notTo.beNil();
//		expect(error).to.beNil();
//
//		GTCommit *mergeBase = [repository mergeBaseBetweenFirstOID:masterBranch.reference.OID secondOID:otherBranch.reference.OID error:&error];
//		expect(mergeBase).notTo.beNil();
//		expect(mergeBase.sha).to.equal(@"f7ecd8f4404d3a388efbff6711f1bdf28ffd16a0");
//	});
//});

SpecEnd
