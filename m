Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A8811E901
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2019 18:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbfLMRNC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 13 Dec 2019 12:13:02 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45413 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728452AbfLMRNB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 12:13:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576257181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uj16ZtmOLHHip8b+6FFKRaNWuc1LSF7Aazups83SpX8=;
        b=Vz1VdlEvKxsrwP8s8SYUq0ea2KEU/XGr4G9MFKnhUrJHFM0aroDQAVM6IL1cOLDtVptRWX
        DjLdUagah9JUi91RJP1VwIew6DZPwZmRRSr6SByvLxNnX5AQPpONKxCfmIull6chNBZmCu
        UBaafrOgUGuADWrapyUSKlFcbYAQ8c4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-gJZY61lOMoy-jfNXkEwlvQ-1; Fri, 13 Dec 2019 12:12:59 -0500
X-MC-Unique: gJZY61lOMoy-jfNXkEwlvQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AA831005502
        for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2019 17:12:58 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2779C19C4F
        for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2019 17:12:58 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/3] xfs: hold ilock across insert and collapse range
Date:   Fri, 13 Dec 2019 12:12:55 -0500
Message-Id: <20191213171258.36934-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a followup to the recent bugfix I sent on collapse range.
Dave suggested that insert/collapse should probably be atomic wrt to
ilock, so this series reworks both operations appropriately. This
survives a couple fstests runs and I'll be running an fsx test over
the weekend...

Brian

Brian Foster (3):
  xfs: open code insert range extent split helper
  xfs: rework insert range into an atomic operation
  xfs: rework collapse range into an atomic operation

 fs/xfs/libxfs/xfs_bmap.c | 32 ++--------------------
 fs/xfs/libxfs/xfs_bmap.h |  3 ++-
 fs/xfs/xfs_bmap_util.c   | 57 ++++++++++++++++++++++------------------
 3 files changed, 36 insertions(+), 56 deletions(-)

--=20
2.20.1

