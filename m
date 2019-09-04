Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15DE8A7B28
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Sep 2019 08:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbfIDGHI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Sep 2019 02:07:08 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50508 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbfIDGHI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 02:07:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xHxyUj6bPk5HkVwf1j0Z/GteeF2Ia/NuVkBTxZw3DJk=; b=mJxywDTWgzG+Y6Fl6anPHIYlt
        ZRvQD4wNjzsBflI6MBeDRBVdEpbnhfP3X+4L9RQIpMwKdOEdDyfZbCyXq4/lY6VZ9jZksh9JhuAD4
        6wQyL0ZB6SrIdhy+QoUZmZSxUfAKbLRNPl1+EVxbpGypk5Vxpg5LexlDXnQp7pBYUNV1MP0T4e7Zt
        pw30G7yykBz8ZBTsL0FTqf8CT4YdW/p3Gm2ME2oDTx67XUdFy4fcm7EHdC1zXYeBJ3YktneCZu0wk
        mMs3VItPPur7Wrx/IKkcqv/6+YYtaFCP+dYqgm0n1NhSHqVoxEIDktEkzGWV6lyUIT4vKuAPc8szp
        lcVt6bCiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i5ORf-0004xh-OF; Wed, 04 Sep 2019 06:07:07 +0000
Date:   Tue, 3 Sep 2019 23:07:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: push the AIL in xlog_grant_head_wake
Message-ID: <20190904060707.GA12591@infradead.org>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904042451.9314-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904042451.9314-2-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +		if (*free_bytes < need_bytes) {
> +			if (!woken_task)
> +				xlog_grant_push_ail(log, need_bytes);
>  			return false;
> +		}

It would be nice to have a comment here with the condensed wisdom from
the commit log.
