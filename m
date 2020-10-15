Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D012428EE67
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 10:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbgJOIXU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 04:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgJOIXU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:23:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0339C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=nYsX/GHAEnHNU/5JYO/ghLr1+w
        R8Ul+meJ8VNEl7SbM5aoZaX9JwbUuZ0DjQ4iqaLu9f4KLm9mUGAyGkL9ldl1o+fi7NMX/vD34Q4Qf
        zai2Co/2zLYjpUuzNCIdmQUav3iMlMsMEHV5xQ8JcJO07zE6iEEyTAudYPru+CysPgsrgdA/8SpbE
        NDnGtMInCmaRV83kA+WjceCn4xbAGK6VGl1N6SzNv5q0fpoMAErBxyBY3xjQs06v7m22rL76iy3GL
        tWEchftdMQN75ZosjAW+LPsHbYC12RXdbJphGJIhw5Qxf90j4Q2pkyrVjYv3ubNpf9mRYypq4JJei
        AIZMbNzg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSyXU-00010O-JH; Thu, 15 Oct 2020 08:23:08 +0000
Date:   Thu, 15 Oct 2020 09:23:08 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v5 2/3] xfs: check tp->t_dqinfo value instead of the
 XFS_TRANS_DQ_DIRTY flag
Message-ID: <20201015082308.GB3583@infradead.org>
References: <1602298461-32576-1-git-send-email-kaixuxia@tencent.com>
 <1602298461-32576-3-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602298461-32576-3-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
