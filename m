Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62F658FC6D
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Aug 2022 14:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbiHKMgZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 11 Aug 2022 08:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235310AbiHKMgQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Aug 2022 08:36:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AE61F2C2;
        Thu, 11 Aug 2022 05:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EjKcNm5XBKv+4XP3DxPH14wZ8amxK8T8GMGh2hMXiMI=; b=wLjsI6J1hyJKgiKQIToeLHhM93
        924eyiMZCuzRN+4o52Ty2oRgMQ/ou/O0sFfMWyfbh9IlvhYVRsXkr78l9O3kgle62Zl//dze285GN
        lOiG5jMGqGj9q6cX6auihyVRYAqaVCUH9VXWCTL05SStnbZ2iUuV7oSCvYRDut1JaDwipsqVFwXB0
        CaCbzqQ96+sbsNU2f4UfZXbFe3SKFrQxAWLFjh1Sj3lRo1zro1sJXWPw8tWG+kpEoVQO1blsCsje0
        8+qVFeuv+Of6s80yyvqD+tXu5P0TZwAKu3XzarphGv/HN8dGjktNu0tZTzqMOhqUIh3A6ow388Kzb
        1E9y882w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oM7Q0-00CA34-NG; Thu, 11 Aug 2022 12:36:08 +0000
Date:   Thu, 11 Aug 2022 05:36:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] common: refactor fail_make_request boilerplate
Message-ID: <YvT3uHD3iBu+jsB4@infradead.org>
References: <165950052948.199134.11841652463463547824.stgit@magnolia>
 <165950053513.199134.15842568650897036461.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165950053513.199134.15842568650897036461.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +_start_fail_scratch_dev()

> +_stop_fail_scratch_dev()

I still think passing an explicit device here vs having specific
helpers for the scratch device would be better.  But overall we
need to do this refatoring and given that the patch looks otherwise
good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
