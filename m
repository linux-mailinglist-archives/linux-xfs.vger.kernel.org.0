Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F90A2EF8
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2019 07:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfH3FeY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Aug 2019 01:34:24 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50766 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfH3FeY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 01:34:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9gAZp/N5rgjCkq0E8TcKLOkGMRs3J2hGlftaU3UvT6s=; b=ocUl2YzBa+rEBagzvx8IHae7Y
        HwlxvjMBA2N1EK2OLknAFHBU4Xh6AUrQTXUz+y9solsY27sA22jaBO8fmZ3xefR/oedB5GcrdVb/i
        6EWVkzM1+/xXq3ka7/rcAzyzhsSYJhTt7yDs3c8WBDJOIsS+VmHTArqoOmLhaK5iq2uhR4WNDWGw0
        YPMQdCe/HL6hc2/S1jd7sAaOG6IqI8Rm9jd1LcHamPvkwfxeVzvGrvrM+pIBDyZ4UiJBEzN/h92Oc
        Qw0q4ZGbmO370rRgGZ/esCBU/kAIf9azFFVARQ2iQarapLXjZ3s2p2UF6twiLurHGgbMiAL/vK3KW
        k1qH2IbLg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3ZYG-0005uk-DL; Fri, 30 Aug 2019 05:34:24 +0000
Date:   Thu, 29 Aug 2019 22:34:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: remove unnecessary indenting from
 xfs_attr3_leaf_getvalue
Message-ID: <20190830053424.GE6077@infradead.org>
References: <20190829113505.27223-1-david@fromorbit.com>
 <20190829113505.27223-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829113505.27223-3-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 09:35:02PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
