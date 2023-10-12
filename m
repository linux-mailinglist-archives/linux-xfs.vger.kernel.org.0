Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B7F7C6848
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Oct 2023 10:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbjJLIeg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Oct 2023 04:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235445AbjJLIeg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 04:34:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D89BA
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 01:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cFQj1U04hs67e7Y9K/9zpcaZZEJuJLpBBT7zuT/L7M8=; b=l+HoTNbBg+5Z6bw3n1V9jG1a12
        Dl12/uluYvC5IpkGPEgDt/nAjZO+OYrY8K0GMR1FIEtQqioDIxjT46wPvdjtZtypTSzj7+4yY7LbR
        spA1Opno7HxmQH3tvjPdeFCm4YJmBGuvB9vobFz0DLBo5SYKVcmBupD93W3qfGjvUxhAQDFwAsgXY
        9ttcyINHA8e+iIbzVs3RGLs9YcqHWJ8EZ+xesXaSRkDTo5XXx1RMx2HFH5Xz2RBPmTO9pXOzFjDd3
        qEUzJT8jDX7jzsinn/hvuQhPPy6X1YuCdDt6kBbIU9PuEinqrvKe+//Nj35qT5q6Sw37BB6YRXEC0
        uBGzJaDQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qqr9O-000CUN-1f;
        Thu, 12 Oct 2023 08:34:34 +0000
Date:   Thu, 12 Oct 2023 01:34:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: allow read IO and FICLONE to run concurrently
Message-ID: <ZSevmga8j3dNl34J@infradead.org>
References: <20231012010845.64286-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012010845.64286-1-catherine.hoang@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 06:08:45PM -0700, Catherine Hoang wrote:
> Clone operations and read IO do not change any data in the source file, so they
> should be able to run concurrently. Demote the exclusive locks taken by FICLONE
> to shared locks to allow reads while cloning. While a clone is in progress,
> writes will take the IOLOCK_EXCL, so they block until the clone completes.

FYI, the first two lines are too long for the normal commit log format.

Can you provide a justification for the change, i.e. worksloads for
which this matters, and what metrics are improved?
