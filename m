Return-Path: <linux-xfs+bounces-14683-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67FB09AFA2B
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Oct 2024 08:38:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E5D1281ACF
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Oct 2024 06:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B96591925BF;
	Fri, 25 Oct 2024 06:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="InA1Udxf"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7841F18C935
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838308; cv=none; b=TZhDucJWSVg4RXePo+r5NZEv29NQnygeLVWPZkIWMWf5wGEfPpADkThLNNOhqQ/aowvz3WC1zcPJSVY0XeZwJE/jerkGOTnvdvGd8NgMN43FRFMQ0N0ua72fOORuTzFflhbTp4qWnG+bmVjaLqgfWdQ1vDBKWK5rFBuwqReD/Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838308; c=relaxed/simple;
	bh=/0s+cECFMrndgKsuUBctaDvSKDcHV3O3N6OFXfIDH6g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MUPvOZbUaakALX1dv/lE+T9aG51EIGJI69IWA5rgR5hmyvt87XNij3qNkvRP80WPWnHb/NH9qWv7wiCtRFXH2CH3d1cDH5BxAiqJE6OGrnrXHWudvxkvd4YgL0CBy1HSyk7R/g9lexZ19tzinlwo6SMvyYwjIDdMMsfjMyPwiZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=InA1Udxf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCCCC4CEC3;
	Fri, 25 Oct 2024 06:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729838308;
	bh=/0s+cECFMrndgKsuUBctaDvSKDcHV3O3N6OFXfIDH6g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=InA1Udxfya4Z5LAj13vlRuOH5GjRondXoW/tBJBpi0TNZcSR8SOcjkY+7i7xbzhxp
	 GBo5z2TqvNcXnydclNAnDxjCOIqvWcY2JrfJysOxYeD/yWyi0za8xWA3b5BxGQihj8
	 vTQ1E/QfT9xItzkE9rhUPmjZdQUNr2bb5Dh/KDgYLYLz0Dy+xEGxuWKkxdMKUrSQ/1
	 aWTqsMTCyM/B3OdMgAFKG4i0veJ8JnSRfslYo2kHl42QnvSY+xp7J5km1gMsA6hHpl
	 Le6CPK2R3uhaAkFhS2kNTbv32svhKQ7u2mgXFl/Hwq5UgS+Gcthkc932lUQAJiHNB0
	 bhsmt3qgFAI/A==
Date: Thu, 24 Oct 2024 23:38:27 -0700
Subject: [PATCH 1/1] xfs_scrub_all: wait for services to start activating
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983774826.3041899.15350842942789677656.stgit@frogsfrogsfrogs>
In-Reply-To: <172983774811.3041899.4175728441279480358.stgit@frogsfrogsfrogs>
References: <172983774811.3041899.4175728441279480358.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

It seems that the function call to start a systemd unit completes
asynchronously from any change in that unit's active state.  On a
lightly loaded system, a Start() call followed by an ActiveState()
call actually sees the change in state from inactive to activating.

Unfortunately, on a heavily loaded system, the state change may take a
few seconds.  If this is the case, the wait() call can see that the unit
state is "inactive", decide that the service already finished, and exit
early, when in reality it hasn't even gotten to 'activating'.

Fix this by adding a second method that watches either for the inactive
-> activating state transition or for the last exit from inactivation
timestamp to change before waiting for the unit to reach inactive state.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 6d831e770359ff ("xfs_scrub_all: convert systemctl calls to dbus")
---
 scrub/xfs_scrub_all.in |   52 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 5e2e0446a99f89..fe4bca4b2edb11 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -249,6 +249,54 @@ class scrub_service(scrub_control):
 				print(e, file = sys.stderr)
 			return 'failed'
 
+	def last_activation(self):
+		'''Retrieve the last activation time, in microseconds since
+		boot.'''
+		global debug
+
+		l = lambda: self.prop.Get('org.freedesktop.systemd1.Unit',
+				'InactiveExitTimestampMonotonic')
+		try:
+			return self.__dbusrun(l)
+		except Exception as e:
+			if debug:
+				print(e, file = sys.stderr)
+			return 0
+
+	def wait_for_startup(self, last_active, wait_for = 30, interval = 0.5):
+		'''Wait for the service to start up.  This is defined as
+		exiting the inactive state.'''
+
+		for i in range(0, int(wait_for / interval)):
+			s = self.state()
+			if debug:
+				print('waiting for activation %s %s' % (self.unitname, s))
+			if s == 'failed':
+				return 1
+			if s != 'inactive':
+				return 0
+			# If the unit is inactive but the last activation time
+			# doesn't match, then the service ran so quickly that
+			# it's already gone.
+			if last_active != self.last_activation():
+				return 0
+			time.sleep(interval)
+
+		s = self.state()
+		if debug:
+			print('waited for startup %s %s' % (self.unitname, s))
+		if s == 'failed':
+			return 1
+		if s != 'inactive':
+			return 0
+
+		# If the unit is inactive but the last activation time doesn't
+		# match, then the service ran so quickly that it's already
+		# gone.
+		if last_active != self.last_activation():
+			return 0
+		return 2
+
 	def wait(self, interval = 1):
 		'''Wait until the service finishes.'''
 		global debug
@@ -278,7 +326,11 @@ class scrub_service(scrub_control):
 			print('starting %s' % self.unitname)
 
 		try:
+			last_active = self.last_activation()
 			self.__dbusrun(lambda: self.unit.Start('replace'))
+			ret = self.wait_for_startup(last_active)
+			if ret > 0:
+				return ret
 			return self.wait()
 		except dbus.exceptions.DBusException as e:
 			# If the unit was masked, the sysadmin doesn't want us


