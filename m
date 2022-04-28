Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D05513440
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Apr 2022 14:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235479AbiD1M5p (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Apr 2022 08:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235489AbiD1M5o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 08:57:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0870CB0A65
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 05:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SNqccSkMKZi/Tq6qFJzowYZIk4
        R00W8+NN4mXfMsrxioW/2gyrlPgeWzUXTOXAg7rWQwu6Qn07SDh/0gZ5kpk2fBvcCVhKQ/u7efhf2
        ka2GyZQ1MH/VDqr99NayHyY0wFhvz34EAx9UVKftW6jMSDagCo4VvWmur32buPiWy6PyApKehzCq6
        Shl2YTp0fEZmgOQd3lZvymswwNhWqwNQ4VD6c81vNpe5LVfQdLGz8WhfS72v36/ryh+xzNnHOWIJe
        3zbyoZ87zes2OI6pOWGvxuQf6cANUbJGwoqxpqHmGVUOo1A//vOvDpgMAaUzNdpwB9e3EUd0ta0XO
        tVVMeiKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk3fA-006ufg-UK; Thu, 28 Apr 2022 12:54:28 +0000
Date:   Thu, 28 Apr 2022 05:54:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: reduce the absurdly large log operation count
Message-ID: <YmqOhLOAXtVcUPk8@infradead.org>
References: <165102071223.3922658.5241787533081256670.stgit@magnolia>
 <165102074605.3922658.2732417123514234429.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165102074605.3922658.2732417123514234429.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
