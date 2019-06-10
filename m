Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4233ADD5
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Jun 2019 06:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfFJESc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jun 2019 00:18:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56991 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbfFJESc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jun 2019 00:18:32 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3221137E80;
        Mon, 10 Jun 2019 04:18:31 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8947600CD;
        Mon, 10 Jun 2019 04:18:24 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH V2 0/2] block: fix page leak by merging to same page
Date:   Mon, 10 Jun 2019 12:18:17 +0800
Message-Id: <20190610041819.11575-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 10 Jun 2019 04:18:31 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

'pages' retrived by __bio_iov_iter_get_pages() may point to same page,
and finally they can be merged to the same page in bio_add_page(), then
page leak can be caused because bio_release_pages() only drops the page
ref once.

Fixes this issue by dropping the extra page ref.

V2:
	- V1 breaks multi-page merge, and fix it and only put the page ref
	if the added page is really the 'same page' 


Ming Lei (2):
  block: introduce 'enum bvec_merge_flags' for __bio_try_merge_page
  block: fix page leak in case of merging to same page

 block/bio.c         | 32 ++++++++++++++++++++++----------
 fs/iomap.c          |  3 ++-
 fs/xfs/xfs_aops.c   |  3 ++-
 include/linux/bio.h |  9 ++++++++-
 4 files changed, 34 insertions(+), 13 deletions(-)

Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
-- 
2.20.1

