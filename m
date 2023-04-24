Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25BA86DD14E
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Apr 2023 07:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjDKFA0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Apr 2023 01:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDKFA0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 01:00:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A334AE6F
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 22:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=gr6629PRIKfsXvZqCuotUV5Nm1
        pROrltDwKipeXjPCG2rxnXKvjXlD26QV/eJYyhvbhN1giICTmhvihK9/JoFxHQx3iFxl+Zgh2jdi5
        3rmu9pf+Ykp7YLQsC6B5IYQbq3bEdIxftGsExg098AUSQf3xkcYtTRbHJC5yPlvoqRWV/iojjB5xZ
        UTAh9S3icVbN8IyGsa7L7vlAaVLkFAe6PVxrCI1TLybjX0ovuM+majJnOP32Zn06tVYIaZxfeMLvy
        ZWudagLa0dRInf5E0XX/BaoJkIjdjSzoc0C1M/YK0qK7mDFe/rLNTLsJelIertbEnc64F8lJ2HHGv
        4MH0u11A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pm67B-00GQUC-1i;
        Tue, 11 Apr 2023 05:00:21 +0000
Date:   Mon, 10 Apr 2023 22:00:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/2] misc: test the dir/attr hash before formatting or
 repairing fs
Message-ID: <ZDTpZWtXlgf6zcCt@infradead.org>
References: <168073967113.1654766.1707855494706927672.stgit@frogsfrogsfrogs>
 <168073968242.1654766.4264241405014258594.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168073968242.1654766.4264241405014258594.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
