Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5932A1379
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Aug 2019 10:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfH2ISX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Aug 2019 04:18:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57998 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfH2ISX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 04:18:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4MBfoyEf5FiltY31KbIOO4m5UsITO5O8zWV/xSKseAY=; b=mmcmqPJwy15Bm0o3n3W7ebNuD
        T1dEke+ES8h/tvq7+9i6QPLzRCq8RMH+F5gZTdLlsE8M09QRizqT2xrZeesxihjoLThPVdy/VArhN
        /ZvCNj6qTXVErjQXIGnFAqJWOWpVD12Z5945RZB0N6OVMtyclE+pxl39cHwfBLEwJGO6dt32UPXwt
        QKnxU4W9S40g5GkbohEjtrcDBPFWn/ANrUK+AlC4biSt9gitexOEWgGnAroGyAOMvdogX5wnp9ns0
        Ypti0WOROslRVnkS0UO6GQxxeifWqi5fWEduvFPGjrL+EUptsMxJMIBw91L5M2iMzXV2CmZHSguQo
        tjkQeNduQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3FQv-0007yR-8Z; Thu, 29 Aug 2019 08:05:29 +0000
Date:   Thu, 29 Aug 2019 01:05:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: factor data block addition from
 xfs_dir2_node_addname_int()
Message-ID: <20190829080529.GB18195@infradead.org>
References: <20190829063042.22902-1-david@fromorbit.com>
 <20190829063042.22902-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829063042.22902-3-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 04:30:39PM +1000, Dave Chinner wrote:
> +			XFS_ERROR_REPORT("xfs_dir2_node_addname_int",
> +					 XFS_ERRLEVEL_LOW, mp);

The function name here is incorret now.  I'd say just use __func__
to avoid that for the future.

Otherwise some of the code flow in the caller looks very ugly just with
this patch, but given that it is all sorted out by the end of the series
I don't really see an issue.

Reviewed-by: Christoph Hellwig <hch@lst.de>
