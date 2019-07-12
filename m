Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA3F067637
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Jul 2019 23:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfGLVbB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 12 Jul 2019 17:31:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56752 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727994AbfGLVbB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Jul 2019 17:31:01 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0F992C058CBA
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 21:31:01 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D76EC5C207
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 21:31:00 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/4] xfsprogs: inch libxfs/trans.c towards xfs_trans_buf.c
Message-ID: <a40115ca-93e2-6dd2-7940-5911988f8fe4@redhat.com>
Date:   Fri, 12 Jul 2019 16:31:00 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 12 Jul 2019 21:31:01 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reorder and then make cosmetic changes to libxfs/trans.c to make
it reasonablly diffable with xfs_trans_buf.c.

At a minimum this makes it a little easier to see where to land new
code.  In the long run maybe we can share trans_buf.c.

-Eric
