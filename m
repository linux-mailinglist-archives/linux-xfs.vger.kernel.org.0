Return-Path: <linux-xfs+bounces-18367-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 944FEA1457F
	for <lists+linux-xfs@lfdr.de>; Fri, 17 Jan 2025 00:23:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A6A51638D9
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Jan 2025 23:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E332451D9;
	Thu, 16 Jan 2025 23:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QPvIotDU"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFB0236A78;
	Thu, 16 Jan 2025 23:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069712; cv=none; b=Gsaj9xduX9yl0KSVDqHsPdLGO+DmHPeukORQOUjI4A5H7BaYYBrvRIyx5xm5FCZGxsb50crvU7+INxDXpxE5z+dP/axFRn3Xl5TYlp0JkF9ci7Ec8x1786xjpMq3GRCJAVuVTnTrrcqUJeQ0rWFy/88cjeys7eYYb6BKnzVhp3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069712; c=relaxed/simple;
	bh=TzSPH8htP0B/uSy/3mcdgLUoLyAq2cf1tvQacUTZe4E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DJKO8Ps3POA2Gyi2WW22BEy5SNXVfreYSlaFCt+7xK6SMUXqh9MNhEpCchlZjaivtJm/C22ENDJI56FpoeRLjPDPzAOr5lwXVBFwkWwKtdqEehuSdk1dbgcuDsPMYPeMnH2l9Jjd9RYFmwXVz+DNmbV/YDibtQ/Ulbbk0y4AJ/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QPvIotDU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8544C4CED6;
	Thu, 16 Jan 2025 23:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737069711;
	bh=TzSPH8htP0B/uSy/3mcdgLUoLyAq2cf1tvQacUTZe4E=;
	h=Date:From:To:Cc:Subject:From;
	b=QPvIotDUVf0zBFimt+yTvc89+/+A+xdpWQKIXrovSyfdY6zalvpw6mQCVJ9nKP3d0
	 WneZpy2VSBNwj4veoA8C2Bi0olu1BrrV/ZxPUN2e+wNb1gD25nWZf2FvBhtqnFdwO4
	 XLxPoc+Yk/rBU2sSY3K3yNoYJq2qiBGCSgFDrGyYWwCQEVkOHpOtPjjCpUKmY60USw
	 D/3k4MSh2Hfj8h+ianGACcEj7lyx1QVR7HDIEl/Hw0HrUQVDfYwbXCSGGYBV0K2bW2
	 WtVbNUkOlzFdKDnG6CfTUGWpOqHjzoVVOxMgrZNhQEuuc0MgO8XzPGGnLiSyRuJPxh
	 aHRxA4Qf9UWTQ==
Date: Thu, 16 Jan 2025 15:21:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHBOMB] fstests: fix check-parallel and get all the xfs 6.13
 changes merged
Message-ID: <20250116232151.GH3557695@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

This patchbomb starts with a very large set of bug fixes that try to fix
all the problems that I found in last year's overhastily merged
check-parallel patchset.  There's really too many of them to get into
here.

Next comes some cleanups for the logwrites code to try to reduce the
instances of people writing logwrites replay tests that break on xfs due
to weird subtleties.

After that are new testscases for the metadata directory tree, realtime
allocation group, realtime quota, and persistent quota options features
that landed in xfs in 6.13.

None of these patches have been reviewed, but I thank you all for your
continued attention.

--Darrick

