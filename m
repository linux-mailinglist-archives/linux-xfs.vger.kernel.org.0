Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE14A28EE6B
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 10:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbgJOIZc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 04:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgJOIZc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:25:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5405FC061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Eb4NDOVrZulV8x8lMq7IlAW9A4HgeGispYu+sh+xl80=; b=cEvQe7L1Je1N/qw+rxq7Yk3Gox
        DmwRo+oxMEW0XxK0zLdD2YMfXHQr0X+boB4J27R3yWT7Nr+RGqXkMkuGnND+UuRdDw0lKJfqQFcQ6
        SXt8yujiZWFLWBj3yr/RR0Y6IKxyJyH7/muPDgA+vdc6u4INAEdm+cfN6RwpcfHsId7ff1WcMp1yx
        rWa8z+U9U89hBtD/SGL/oX35XeFkk9+YlyBb1txPg+hAm/kcAUZoW9U7pTG4tt0iWUoVRdrTdqVdz
        h3ewenz0ZXEcRTJ0MwJtQIrZigngW5ZIJYXHttfym5fWiydBAFHXoh2qAFOYzBj6VXew0+a3MEWwe
        7UjD/yFA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSyZc-00019c-Ub; Thu, 15 Oct 2020 08:25:21 +0000
Date:   Thu, 15 Oct 2020 09:25:20 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v5 3/3] xfs: directly return if the delta equal to zero
Message-ID: <20201015082520.GC3583@infradead.org>
References: <1602298461-32576-1-git-send-email-kaixuxia@tencent.com>
 <1602298461-32576-4-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602298461-32576-4-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +		xfs_trans_mod_dquot(tp, dqp,
> +				    flags & XFS_QMOPT_RESBLK_MASK,
> +				    nblks);
> +		xfs_trans_mod_dquot(tp, dqp,
> +				    XFS_TRANS_DQ_RES_INOS,
> +				    ninos);

This can be shortened to:

		xfs_trans_mod_dquot(tp, dqp, flags & XFS_QMOPT_RESBLK_MASK,
				    nblk);
		xfs_trans_mod_dquot(tp, dqp, XFS_TRANS_DQ_RES_INOS, ninos);

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
