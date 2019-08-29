Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F41A1398
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Aug 2019 10:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbfH2I0T (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Aug 2019 04:26:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58176 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfH2I0T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 04:26:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KKxM1ohonNk+9+tZFmaLW+97wP6fbHmBlTrrv20JG2g=; b=GtZHMhD6CUtdI55iE+z8rUXwD
        xGJo3+2ToLKzxSn107vwYOLL56fhb6ClQ28+QRh+M1IpFNqVx4pEk5Y8CXxZcXczKDNSRq/ONeT1C
        3wZqt677Y2NInrVupsb9Uscct0/e/2woOXj7kJqQPjA/ZoSixncuUL2G1RWIdcPZY8iswY168GcQn
        Gcet9+Wve2KFFZvla7ZEAyhEsZBxGBNq8pASjUQeUP2Damh+y3+/qwIJ5ZYZgSpgBUCHMXH4uwFKD
        fUzb6zruvvmmT2P5oggDzi/bwyfTdmkuDlbVblOHSNUmTlMsPHO0MRCUvYJe4FD5z/hMGgnstJbdK
        f6Qm0VbeA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3Fl4-00068o-RH; Thu, 29 Aug 2019 08:26:18 +0000
Date:   Thu, 29 Aug 2019 01:26:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: log proper length of btree block in scrub/repair
Message-ID: <20190829082618.GB18614@infradead.org>
References: <f66b01bb-b4ce-8713-c3db-fbbd39703737@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f66b01bb-b4ce-8713-c3db-fbbd39703737@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 27, 2019 at 02:17:36PM -0500, Eric Sandeen wrote:
> xfs_trans_log_buf() takes a final argument of the last byte to
> log in the buffer; b_length is in basic blocks, so this isn't
> the correct last byte.  Fix it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> just found by inspection/pattern matching, not tested TBH...

Looks good.  And I wonder if we should fix the interface instead,
as it seems to lead to convoluted coe in just about every caller.

Reviewed-by: Christoph Hellwig <hch@lst.de>
