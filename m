Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81CA3615D75
	for <lists+linux-xfs@lfdr.de>; Wed,  2 Nov 2022 09:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiKBIQM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 2 Nov 2022 04:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiKBIQH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2022 04:16:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA63B1F9D4
        for <linux-xfs@vger.kernel.org>; Wed,  2 Nov 2022 01:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GJ1bF0kStcZLn+RukuJw7sGB+tkKm3NVFWZybNiHxNo=; b=lphLYYYX/9Jqb+xKlKxe5ugMGY
        0BDYekz7WLmSZeWDaqblizBPbgWsXDJ8JXzttv5++AuU0rX0naDP9vUVCcHbd9PG8L3UyuJcydn8r
        +hh3A/tEJvbue/ZFZ05dFi7nyqE0CXSC/3Cx9645IIChg23mg6Rq03rJ5T6u1+aaRyqQx8ib35hjv
        jUpo/jaT6YLh6T4OJTYqFiouyxCen5zoA6czziF0IXrE6vZtjb7/6So46gYbxZVFzYg3BhuXTSrtk
        JYE/ub58AjUj5Vcn9q3w58zIpF6LbPB+nSSUe8F+7WBNe50iV0MtqfrqFwxLEqKNVgZpDUnm0EuBm
        /OHXRlPA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oq8uh-008nsa-Qu; Wed, 02 Nov 2022 08:15:55 +0000
Date:   Wed, 2 Nov 2022 01:15:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: redirty eof folio on truncate to avoid filemap flush
Message-ID: <Y2InOzkYfW/4aKwt@infradead.org>
References: <20221028130411.977076-1-bfoster@redhat.com>
 <20221028131109.977581-1-bfoster@redhat.com>
 <Y1we59XylviZs+Ry@bfoster>
 <20221028213014.GD3600936@dread.disaster.area>
 <Y1xqkT1vZ9OmzDmH@magnolia>
 <20221029220131.GF3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221029220131.GF3600936@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 30, 2022 at 09:01:31AM +1100, Dave Chinner wrote:
> Right, think of iomap_truncate_page() as having exactly the same
> responsibilites as block_truncate_page() has for filesystems using
> bufferheads. i.e. both functions need to ensure the disk contents
> are correctly zeroed such that the caller can safely call
> truncate_setsize() afterwards resulting in both the on-disk state
> and in-memory state remaining coherent.

XFS always had these kinds of hacks even when it was using
block_truncate_page.  That being said, I fully agree that handling
it in iomap is the absolutely right thing to do and we should have
done it earlier.
