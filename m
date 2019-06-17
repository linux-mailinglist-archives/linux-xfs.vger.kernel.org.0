Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 215454831C
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Jun 2019 14:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbfFQMww (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Jun 2019 08:52:52 -0400
Received: from foobar.grin.hu ([91.146.180.88]:53916 "EHLO foobar.grin.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfFQMww (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Jun 2019 08:52:52 -0400
X-Greylist: delayed 2601 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jun 2019 08:52:51 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=grin.hu;
        s=foobar; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iek1z9EV8VH7vbObdDrZRrHgUVdfdel8aF79upwImbY=; b=tMyJ+z3eJW6cIsKRfJz6s+kH+M
        0NN+xkavoj5tmWrJYRZLoUqHI1+Lux5cygngIFAIRKoNS6HqzFGabePW4NzVAyz7f3leVBcUtHV2h
        uUqNlVKr4a6MEotDA9/RAhuoYflhKGYpEI3X7mPYZGnratHFRtlcBwbRdmz5qEKy8iEuWah5lMbSm
        CpMRvBymnuMKikyIHhmJoeP7uG0IjgOIuCe4w2TsEj/n0fkj/HEHu+HXWwSC1OBmj5NUOmbk4z20u
        x18bVUaPLCl7H9UTTLQV5i2civFDOXxDIMjV65DtCs0c8De5rpRVHsjBIpfp26kAS7YA6/2MYSie+
        lp9rQ9rw==;
Received: from 20014c4c115502000000000000000042.catv.pool.telekom.hu ([2001:4c4c:1155:200::42] helo=narya.grin.hu)
        by foobar.grin.hu with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <lxfs@drop.grin.hu>)
        (authenticated <grin@grin.hu>)
        id 1hcqRx-00Ff15-PN
        for linux-xfs@vger.kernel.org; Mon, 17 Jun 2019 14:09:29 +0200
Date:   Mon, 17 Jun 2019 14:09:24 +0200
From:   grin <lxfs@drop.grin.hu>
To:     linux-xfs@vger.kernel.org
Subject: xfs_db sigsegv, xfs.org wiki and misc
Message-ID: <20190617140924.7db29e91@narya.grin.hu>
Organization: foobar.hu
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Score: -8.8 (--------)
X-Scan-Signature: aa676899302e0bf45cd835a9767c1255
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

I haven't checked XFS project lately, and that's a decade or so, it
means that when I have met a bug I went out and tried to see where and
how to report. Just mentioning the following, since you may not be
aware from the inside:

The xfs.org seems to be the "main" xfs website, search gives it first,
and has a huge amount of informations. Problem is: most links point to
nonexistant pages (SGI links hijacked by HP main page), including those
mentioning documentation, development or suggest bug reporting. Only
two valid pointers are the #xfs on FreeNode and this mailing list. Some
mentioned https://xfs.wiki.kernel.org/ which is bacially impossible to 
find unless looking for it specifically, and it doesn't contain much
info anyway. So I can't see who to mention this to, maybe you know.

Anyway. xfs_db SIGSEGV, v5.0, pretty reliably, on
> inode <n>
> type inode
> print 
 [...lots of output of the extents...]
 crash

I am not sure how it's handled: whether it's a very low level utility
and sigsegv is a way to show "you're doing something wrong", or rather
it is a bug and shall be fixed. If you would kindly tell me whether
I shall report it anywhere, send metadump, or anything, I would be much
happier (to know at least).

(At least one external tool tries to use it and it's bitten by the
crash.)

Thanks,
g
