Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8924EE4FC1
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Oct 2019 17:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408011AbfJYPDq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 25 Oct 2019 11:03:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48646 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfJYPDq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 11:03:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pLHKWzt1LYRfn/UEXQ9u/VsQ5IVZFtCkMIdJyCqaKek=; b=mvXCq6cCjCHxPDD6jfxfGYLNT
        mJE/UODlpF0zLhJNn6z0S4uZLJQCjQVLcIVrknOQQOz3rJDuBFgEYL7Q1UCswXT2REIAiBlec/Bm/
        t+gpbOtbxiWyTgIBr6pxdG34406UCmjAGH/YiYqudk/eCSBMlHwC3ZrzrwlSFEUPUAp7IuEvkVzM5
        IhepL+HaexWn6aX9JzyeJ+LArIhLxYUxvepgS0tI85d/V8YfNdvxN6KUelAjNPmWQXlMnTUthIWVI
        OOUVa0sLAgFRCShIOCNGHiIG4XcFbqYJPZ3osXUORxRo95jLEeMvdwOJoLD0Tdp4a0RaP4X5bOZ8j
        3nGMOam0w==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO17w-0006SS-De
        for linux-xfs@vger.kernel.org; Fri, 25 Oct 2019 15:03:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: a few iomap / bmap cleanups
Date:   Fri, 25 Oct 2019 17:03:28 +0200
Message-Id: <20191025150336.19411-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series cleans up a few lose ends through the iomap and bmap
write path.
