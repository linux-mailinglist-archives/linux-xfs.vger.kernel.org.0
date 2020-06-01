Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77FC11EA577
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jun 2020 16:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgFAOCC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Jun 2020 10:02:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34250 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726017AbgFAOCC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 10:02:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591020120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sk3PSr15XqMDqCChaP2wsvPijbfZTGVH/kreJCQFyIA=;
        b=RIY/BarUkw6dptTpDGatfQ36k71sbUm91Ovbvzp7VcEPYQwaeXQ636v77FU9YZp323Jcen
        5n79ualPjhNl7R3pwI4SxbHPMW8pmW8lz+sNRmijOejSUqlpszRa4MIQiTDq1J6ZQkALwV
        b5MsBhRyMZEMwFy82t8PTc44CykPTqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-O42ULNsKMv279cP0dRDBAw-1; Mon, 01 Jun 2020 10:01:58 -0400
X-MC-Unique: O42ULNsKMv279cP0dRDBAw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 289B41054F9F
        for <linux-xfs@vger.kernel.org>; Mon,  1 Jun 2020 14:01:58 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.194.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86ADA78EE7
        for <linux-xfs@vger.kernel.org>; Mon,  1 Jun 2020 14:01:57 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] Bypass sb geometry if custom alignment is supplied on mount
Date:   Mon,  1 Jun 2020 16:01:51 +0200
Message-Id: <20200601140153.200864-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

this is just a small series where the main goal is achieved by patch 2. Patch one is
just a small fix on mp->m_dalign and mp->m_swidth I spotted when working on
patch 2.

Carlos Maiolino (2):
  xfs: Fix xfs_mount sunit and swidth types
  xfs: Bypass sb alignment checks when custom values are used

 fs/xfs/libxfs/xfs_bmap.c   |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c |  2 +-
 fs/xfs/libxfs/xfs_ialloc.h |  2 +-
 fs/xfs/libxfs/xfs_sb.c     | 30 +++++++++++++++++++-----------
 fs/xfs/xfs_mount.c         |  4 ++--
 fs/xfs/xfs_mount.h         |  6 ++++--
 fs/xfs/xfs_super.c         | 11 ++++++-----
 fs/xfs/xfs_trace.h         |  7 ++++---
 8 files changed, 38 insertions(+), 26 deletions(-)

-- 
2.26.2

