Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC2728544C
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Oct 2020 00:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgJFWGp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Oct 2020 18:06:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:49754 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbgJFWGp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Oct 2020 18:06:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1602022003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dNrS/qfmb/Wf7ZBVNuoRowt6W3Ol6Tgx8pLLAbpvZs8=;
        b=LU5iCSPzHVkSVvkarr2x/WCqCknm6FWmJ5ZNmXI9WdrMK25oWqGHkQ4a3gwFLYVSDpX/UH
        wazDssYxN52pXOp8altse0NEKRUODHMBQBH0zUZb+f9ixzkhu6/utl32oHeL47Ybwg9HJc
        gJCUdDtgZ+yAfopaLtU7AK/ztVMCIsU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ABBE9AF49;
        Tue,  6 Oct 2020 22:06:43 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfsdump: obsolete file type handling cleanups
Date:   Wed,  7 Oct 2020 00:07:02 +0200
Message-Id: <20201006220704.31157-1-ailiop@suse.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just a couple of code and doc removals for file types that were never
supported in Linux (S_IFMNT, S_IFNAM).

Anthony Iliopoulos (2):
  xfsdump: remove obsolete code for handling mountpoint inodes
  xfsdump: remove obsolete code for handling xenix named pipes

 doc/files.obj     | 2 +-
 doc/xfsdump.html  | 6 ++----
 dump/content.c    | 6 ------
 dump/inomap.c     | 3 ---
 restore/content.c | 8 --------
 5 files changed, 3 insertions(+), 22 deletions(-)

-- 
2.28.0

