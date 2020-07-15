Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943AC220ED9
	for <lists+linux-xfs@lfdr.de>; Wed, 15 Jul 2020 16:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgGOOIl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 Jul 2020 10:08:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26834 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728282AbgGOOIk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 10:08:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594822119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZgN4LQb+/L8eZDjliJhPR8o+24wmpJExdFUrgtqib88=;
        b=IPumvi2vKJu41U6KbZKwV3uuAhF968LubJTiIhW9yJResqeC1RpLoFLLAASTO4ULq8+eim
        HT4KRLEDtj6hixBa2gI9ea4cMHdnRx3As/PHYHukOJLCgNJj/N9Pzw0N5XpkXsaqVyClpc
        2r8xkq5kE9UJ5mb8JaujBe2FXlcuQBE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-wacpOCNfMU-7Ut27jtWxIg-1; Wed, 15 Jul 2020 10:08:38 -0400
X-MC-Unique: wacpOCNfMU-7Ut27jtWxIg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3022119057A1
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 14:08:37 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7E4E5D9C5
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 14:08:36 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/4] xfsprogs: remove custom dir2 sf fork verifier from repair
Date:   Wed, 15 Jul 2020 10:08:32 -0400
Message-Id: <20200715140836.10197-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These are some tweaks to eliminate the custom sf dir verifier code in
phase 6 of xfs_repair. Note that I don't quite recall how thoroughly I
reviewed the first couple patches, but Christoph was asking for this
recently for some libxfs sync work and I'm running out of time before I
disappear for a few weeks, so I wanted to get it on the list. Thoughts,
reviews, flames appreciated.

Brian

Brian Foster (4):
  repair: set the in-core inode parent in phase 3
  repair: don't double check dir2 sf parent in phase 4
  repair: use fs root ino for dummy parent value instead of zero
  repair: remove custom dir2 sf fork verifier from phase6

 repair/dino_chunks.c |  9 +------
 repair/dir2.c        |  8 ++++---
 repair/phase6.c      | 56 ++------------------------------------------
 3 files changed, 8 insertions(+), 65 deletions(-)

-- 
2.21.3

