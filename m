Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D3E535934
	for <lists+linux-xfs@lfdr.de>; Fri, 27 May 2022 08:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbiE0GSm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 27 May 2022 02:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236231AbiE0GSl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 02:18:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3735266F88;
        Thu, 26 May 2022 23:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Ly127bCv0VwPPQ7rRDrqfwwCLy
        x8ZfIlflMqQ1ufjrLriPxNfHf07l6++JjEV5KwWX2WAWs1eKsRjghLXZnFMk73n/vGi0zj7Kyq8j3
        hFRz4q5J5EDC768si+ekY3PNdqrpeboQtzB8fIte7fYfGo/uzg5A2xapEqNVUZYvlBSAA663nWKzT
        eF1UFD7jcmETmIM93bp/uSQLYaXTfdWH+b36wJIcC8klRCJOMM6vGZJie1hlPBKSxXOtArCk5IV1I
        on2FdPAM7hh7gGw8lnURxhFhOYXJjskcKbEw6QaNMsTC6VCrLBKgSWbivLjT2cYbukpPeooVmqJmF
        wKqYg/hg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nuTIu-00GkFo-Co; Fri, 27 May 2022 06:18:32 +0000
Date:   Thu, 26 May 2022 23:18:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zorro Lang <zlang@redhat.com>, Eryu Guan <guaneryu@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs/545: check for fallocate support before running test
Message-ID: <YpBtODduahS/jjq+@infradead.org>
References: <Yo03czi2EzyKy2/c@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo03czi2EzyKy2/c@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
